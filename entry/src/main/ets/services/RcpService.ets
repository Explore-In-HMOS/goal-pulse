import { rcp } from '@kit.RemoteCommunicationKit';
import { Constants } from '../common/utils/Constants';
import { BusinessError } from '@kit.BasicServicesKit';

export function sessionConfig(isNews: boolean): rcp.SessionConfiguration {
  return {
    baseAddress: isNews ? (Constants.HTTPS + Constants.BASE_URL_FOR_NEWS) : (Constants.HTTPS +
    Constants.BASE_URL_FOR_SPORT_DATA),
     headers: {
       'Accept': 'application/json',
       'x-apisports-key': 'YOUR_API_KEY_HERE'
     },
    requestConfiguration: {
      transfer: {
        timeout: {
          connectMs: 1000 * 60 * 2,
          transferMs: 1000 * 60 * 2
        }
      }
    }
  };
}

export function postHttp(url: string, data: object, isNews: boolean = false) {
  const session = rcp.createSession(sessionConfig(isNews));
  return session.post(`/${url}`, data)
    .then((res) => res.toJSON())
    .catch((err: BusinessError) => {
      console.error(`Response err: Code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err)}`);
    })
    .finally(() => {
      session.close();
    });
}

export function getHttp(url: string, isNews: boolean = false) {
  const session = rcp.createSession(sessionConfig(isNews));
  const fullUrl = `/${url}`;

  console.info(`[HTTP] GET ${fullUrl}`);

  return session
    .get(fullUrl)
    .then((res) => {
      const json = res.toJSON();
      console.info(`[HTTP] OK ${fullUrl} body=${JSON.stringify(json)}`);
      return json;
    })
    .catch((err: BusinessError) => {
      console.error(`[HTTP] ERR ${fullUrl} code=${JSON.stringify(err.code)} err=${JSON.stringify(err)}`);
    })
    .finally(() => {
      session.close();
    });
}

export function putHttp(url: string, data: object, isNews: boolean = false) {
  const session = rcp.createSession(sessionConfig(isNews));
  return session.put(`/${url}`, data).then((res) => res.toJSON()).finally(() => {
    session.close();
  });
}