import {ChildProcessWithoutNullStreams, SendHandle, Serializable, spawn} from "child_process";

export const runApp = async (): Promise<void> => {
  console.log(`\n\n\n [/run.sh] Start`);
  const stderr = '';
  const envConf = await getEnvConf();

  const args: string[] = [];
  const path = '/run.sh';

  console.log(`\n\n\n [runApp] Running migration path ${path} with args ${JSON.stringify(args)}`);

  const process =  spawn(path, args, envConf);

  await onExit(process, stderr);
};

const getEnvConf = async (): Promise<any> => {

  return {
    env: {
      "PWD": "/function",
      "FORCE_REACT_PANEL": "",
      "GF_PATHS_HOME": "/usr/share/grafana",
      "HOME": "/home/grafana",
      "TERM": "xterm",
      "SHLVL": "1",
      "GF_PATHS_PROVISIONING": "/etc/grafana/provisioning",
      "FUNCTION_DIR": "/function",
      "GF_PATHS_DATA": "/var/lib/grafana",
      "GF_PATHS_LOGS": "/var/log/grafana",
      "PATH": "/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      "GF_PATHS_PLUGINS": "/var/lib/grafana/plugins",
      "GF_PATHS_CONFIG": "/etc/grafana/grafana.ini"
    },
    cwd: '/',
    stdio: 'inherit' //feed all child process logging into parent process
  }
};

const onExit = async (childProcess: ChildProcessWithoutNullStreams, logs: any): Promise<void> => {
  console.log('Existing the process: ');
  return new Promise((resolve, reject) => {
    childProcess.once('exit', (code: number, signal: string) => {
      if (code === 0) {
        console.log(`Process closed with ${logs}`)
        resolve(undefined);
      } else {
        reject(new Error(`Exit with error code: ${code} and logs: ${logs} `));
      }
    });
    childProcess.once('message', (message: Serializable, sendHandle: SendHandle)=> {
      console.log(message);

    })
    childProcess.once('error', (err: Error) => {
      reject(err);
    });

  });
}
