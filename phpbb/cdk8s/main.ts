import {Construct} from 'constructs';
import {App, Chart, ChartProps} from 'cdk8s';
import {Deployment, Env, Secret} from "cdk8s-plus-25";

export class MyChart extends Chart {
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

const app = new App();
new MyChart(app, 'cdk8s');
app.synth();
