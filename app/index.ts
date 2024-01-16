import { DOMParser } from "https://deno.land/x/deno_dom@v0.1.43/deno-dom-wasm.ts";
import { marky } from "https://deno.land/x/marky@v1.1.6/mod.ts";
import { Client as MYSQLClient } from "https://deno.land/x/mysql@v2.12.1/mod.ts";
import { GetObjectCommand, S3Client } from "npm:@aws-sdk/client-s3";

try {
    // GET HTML TEMPLATE
    const htmlTemplate = await Deno.readTextFile("./index.html");
    const document = new DOMParser().parseFromString(htmlTemplate, "text/html")!;
    const talk = document.createElement("article");

    // GET DESCRIPTION MARKDOWN FROM S3
    const s3Client = new S3Client({ region: 'eu-west-1' });
    const getS3DescriptionFile = new GetObjectCommand({
        Bucket: "bash-to-js",
        Key: "description.md",
    });
    const descriptionFile = await s3Client.send(getS3DescriptionFile);
    const descriptionMarkdown = await descriptionFile.Body.transformToString();

    // APPEND MARKDOWN TO DOCUMENT BODY
    talk.innerHTML = marky(descriptionMarkdown);

    // GET SPEAKERS FROM DB
    const dbClient = await new MYSQLClient().connect({
        hostname: Deno.env.get('DB_HOSTNAME'),
        username: Deno.env.get('DB_USER'),
        db: Deno.env.get('DB_NAME'),
        password: Deno.env.get('DB_PASSWORD'),
    });

    const speakers = await dbClient.execute("SELECT name, avatar FROM speakers");

    // APPEND SPEAKERS TO DOCUMENT BODY
    if (speakers.rows && speakers.rows.length > 0) {
        const speakersList = document.createElement("ul");
        speakersList.setAttribute("class", "speakers");

        speakers.rows.forEach(({ name, avatar }) => {
            const speaker = document.createElement("li");
            const speakerAvatar = document.createElement('img');

            speakerAvatar.setAttribute('src', avatar);
            speakerAvatar.setAttribute('alt', name);

            speaker.innerText = name;
            speaker.setAttribute("class", "speaker");
            speaker.appendChild(speakerAvatar);

            speakersList.appendChild(speaker);
        });

        talk.appendChild(speakersList);
        document.body.appendChild(talk);
    }

    Deno.serve(() => new Response(document.documentElement?.outerHTML, {
        status: 200,
        headers: {
            "content-type": "text/html",
        },
    }));
} catch (e) {
    console.error(e);
}