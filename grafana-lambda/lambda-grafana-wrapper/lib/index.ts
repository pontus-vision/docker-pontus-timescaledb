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
      maxRetries: 5,
    })

    const resp = await restClient.request(
      event.httpMethod,
      `http://localhost:3000${ (!event.path.startsWith('/'))? '/'+ event.path : event.path}`,
      (event.body) ? event.body!: '', event.headers);

    const headers: Record<string,any> = {}
    if (resp.message.headers){
      for (const header in resp.message.headers){
        headers[header] = resp.message.headers[header];
      }
    }

    return {
      statusCode: resp.message.statusCode!,
      headers:headers,
      // headers: resp.message.headers,
      body: await resp.readBody(),
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

