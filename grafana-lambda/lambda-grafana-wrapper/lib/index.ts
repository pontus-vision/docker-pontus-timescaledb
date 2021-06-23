import {APIGatewayProxyEvent, APIGatewayProxyResult} from 'aws-lambda';
import {runApp} from "./spawn";
import {HttpClient} from 'typed-rest-client/HttpClient';

const region = 'eu-west-2';


const app = runApp();

exports.handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  try {
    const restClient = new HttpClient('tr-client', undefined, {
      headers: event.headers,
      allowRedirects: false,
      allowRedirectDowngrade: false,
      ignoreSslError: true,
      maxRetries: 5,
    })

    const reqUrl = `http://localhost:3000${ (!event.path.startsWith('/'))? '/'+ event.path : event.path}`
    console.log (`#####123######### Creating connection to URL ${reqUrl}; event = ${JSON.stringify(event)}`)
    const resp = await restClient.request(
      event.httpMethod,
      reqUrl,
      (event.body) ? event.body!: '', event.headers);

    const headers: Record<string,any> = {}
    if (resp.message.headers){
      for (const header in resp.message.headers){
        headers[header] = resp.message.headers[header];
      }
    }
    console.log (`################## got response :${JSON.stringify(resp.message.headers)}`)
    const body = await resp.readBody();
    console.log (`################## got response :${body}`)

    return {
      statusCode: resp.message.statusCode||200,
      headers:headers,
      // headers: resp.message.headers,
      body: body,
      isBase64Encoded: false,

    };

  } catch (error) {
    return buildRequest(
      401,
      {
        message: 'Error: Failed to process request',
        errorType: error.constructor.toString(),
        errorMessage: error.message,
        stackTrace: error.stack,
      },
      event
    );
  }
};

const buildRequest = (
  statusCode: number,
  body: any,
  event: APIGatewayProxyEvent
) => ({
  statusCode: statusCode,
  headers: {
    'Content-Type': 'application/json',
    'PV-Debug': JSON.stringify(event.headers),
  },
  body: JSON.stringify(body),
});

