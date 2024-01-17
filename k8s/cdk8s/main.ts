import {Construct} from 'constructs';
import {App, Chart, ChartProps} from 'cdk8s';
import {Deployment, Env, ImagePullPolicy, Ingress, IngressBackend, Secret} from "cdk8s-plus-25";
import {SecretsManager} from "@aws-sdk/client-secrets-manager";
import {fromIni} from "@aws-sdk/credential-providers";


export class SimpleAppChart extends Chart {
    constructor(scope: Construct, id: string, secrets: Record<string, string>, props: ChartProps = {}) {
        super(scope, id, props);

        const secret = new Secret(this, 'app-secret');
        for (const key in secrets) {
            secret.addStringData(key, secrets[key]);
        }

        const appDeployment = new Deployment(this, 'app-deployment', {
            containers: [
                {
                    image: 'app:latest',
                    imagePullPolicy: ImagePullPolicy.IF_NOT_PRESENT, // mandatory for minikube
                    envFrom: [Env.fromSecret(secret)],
                    ports: [{number: 8000}],
                    securityContext: {
                        readOnlyRootFilesystem: true,
                        ensureNonRoot: false,
                        user: 0,
                        group: 0,
                        privileged: true,
                        allowPrivilegeEscalation: true
                    }
                }
            ],
        });

        const appService = appDeployment.exposeViaService({
            ports: [
                {
                    port: 5678,
                    targetPort: 8000
                }
            ]
        });

        const ingress = new Ingress(this, 'ingress');
        ingress.addHostRule('app.local', '/', IngressBackend.fromService(appService))

    }
}

const loadSecrets = async (secretId: string): Promise<Record<string, string>> => {
    const client = new SecretsManager(
        {
            credentials: fromIni()
        });
    return client.getSecretValue({
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


(async () => {

    const secrets = await loadSecrets("bash2js")

    const app = new App();
    new SimpleAppChart(app, 'cdk8s', secrets);
    app.synth();

})();


