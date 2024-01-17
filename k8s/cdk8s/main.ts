import {Construct} from 'constructs';
import {App, Chart, ChartProps} from 'cdk8s';
import {Deployment, Env, Secret} from "cdk8s-plus-25";
import {SecretsManager} from "@aws-sdk/client-secrets-manager";
import {fromIni} from "@aws-sdk/credential-providers";


 const loadSecrets = async (secretId: string) => {
    const client = new SecretsManager(
        {
            credentials:  fromIni()
        });
    return await client.getSecretValue({
            SecretId: secretId
        }
    )
        .then(data => {
            if (data.SecretString) {
                return data.SecretString
            }
            throw new Error(`SecretsManager ${secretId} is missing`)
        })
        .then(secret => JSON.parse(secret))
}

export class SimpleAppChart extends Chart {
    constructor(scope: Construct, id: string, props: ChartProps = {}) {
        super(scope, id, props);
        // define resources here

        const secret = new Secret(this, 'Secret');
        secret.addStringData('password', 'some-encrypted-data');

        new Deployment(this, 'FrontEnds', {
            containers: [
                {
                    image: 'node',
                    envFrom: [Env.fromSecret(secret)]
                }
            ],

        });

    }
}

(async () => {
    try {
        const secrets = await loadSecrets("template-deployment")

        const app = new App();
        new SimpleAppChart(app, 'cdk8s');
        app.synth();
    } catch (e) {
        // Deal with the fact the chain failed
    }
    // `text` is not available here
})();


