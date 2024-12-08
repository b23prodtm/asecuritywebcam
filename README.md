![](https://github.com/b23protm/asecuritywebcam/blob/master/balena-cam/app/client/balena-cam-readme.png?raw=true)[![CircleCI](https://dl.circleci.com/status-badge/img/gh/b23prodtm/asecuritywebcam/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/b23prodtm/asecuritywebcam/tree/main)

Live stream your balena device's camera feed, featuring an [RTSP proxy](https://github.com/kerberos-io/camera-to-rtsp).

## Getting started

Running this project is as simple as deploying it to a fleet.

One-click deploy to balenaCloud:

[![deploy with balena](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/b23prodtm/asecuritywebcam)

**or**

- Sign up on [balena.io](https://balena.io/) and follow our [Getting Started Guide](https://balena.io/docs/learn/getting-started).
- Clone this repository to your local workspace.
- Unset (delete) the environment variable `BALENA_HOST_CONFIG_gpu_mem` or `RESIN_HOST_CONFIG_gpu_mem` if exists, from the `Configuration` side tab under "fleets".
- Set these variables in the `Configuration` side tab under "fleets".

  - `BALENA_HOST_CONFIG_start_x` = `1`
  - Set all the following `gpu_mem` variables so your Pi can autoselect how much memory to allocate for hardware accelerated graphics, based on how much RAM it has available

    | Key                                   | Value     |
    | ------------------------------------- | --------- |
    | **`BALENA_HOST_CONFIG_gpu_mem_256`**  | **`192`** |
    | **`BALENA_HOST_CONFIG_gpu_mem_512`**  | **`256`** |
    | **`BALENA_HOST_CONFIG_gpu_mem_1024`** | **`448`** |
    | `MTX_WEBRTCADDITIONALHOSTS` | Specify the hostname network IP address to publish the stream to |
    | `MTX_PATH` | cam or webcam as defined in YAML RTSP-configuration | 
    | `SHM_SIZE`| 10G (=10 Gigabytes) Specify Shared Memory Usage |

- Using [Balena CLI](https://www.balena.io/docs/reference/cli/), push the code with `balena push <fleet-name>`.
- See the magic happening, your device is getting updated 🌟Over-The-Air🌟!
- In order for your device to be accessible over the internet, toggle the switch called `PUBLIC DEVICE URL`.
- Once your device finishes updating, you can watch the live feed by visiting your device's public URL.

### Password Protect your balenaCam device

To protect your balenaCam devices using a username and a password set the following environment variables.

| Key            | Value                      |
| -------------- | -------------------------- |
| **`username`** | **`yourUserNameGoesHere`** |
| **`password`** | **`yourPasswordGoesHere`** |

💡 **Tips:** 💡

- You can set them as [fleet environment variables](https://www.balena.io/docs/learn/manage/serv-vars/#fleet-environment-and-service-variables) and every new balenaCam device you add will be password protected.
- You can set them as [device environment variables](https://www.balena.io/docs/learn/manage/serv-vars/#device-environment-and-service-variables) and the username and password will be different on each device.

### Optional Settings

- To rotate the camera feed by 180 degrees, add a **device variable**: `rotation` = `1` (More information about this on the [docs](https://www.balena.io/docs/learn/manage/serv-vars/)).
- To suppress any warnings, add a **device variable**: `PYTHONWARNINGS` = `ignore`

### TURN server configuration

If you have access to a TURN server and you want your balenaCam devices to use it. You can easily configure it using the following environment variables. When you set them all the app will use that TURN server as a fallback mechanism when a direct WebRTC connection is not possible.

| Key                 | Value                                              |
| ------------------- | -------------------------------------------------- |
| **`STUN_SERVER`**   | **`stun:stun.l.google.com:19302`**                 |
| **`TURN_SERVER`**   | **`turn:<yourTURNserverIP>:<yourTURNserverPORT>`** |
| **`TURN_USERNAME`** | **`<yourTURNserverUsername>`**                     |
| **`TURN_PASSWORD`** | **`yourTURNserverPassword`**                       |

## Additional Information

- This project uses [WebRTC](https://webrtc.org/) (a Real-Time Communication protocol).
- A direct WebRTC connection fails in some cases.
- This current version uses mjpeg streaming when the webRTC connection fails.
- Chrome browsers will hide the local IP address from WebRTC, making the page appear but no camera view. To resolve this try the following
  - Navigate to chrome://flags/#enable-webrtc-hide-local-ips-with-mdns and set it to Disabled
  - You will need to relaunch Chrome after altering the setting
- Firefox may also hide local IP address from WebRTC, confirm following in 'config:about'
  - media.peerconnection.enabled: true
  - media.peerconnection.ice.obfuscate_host_addresses: false

## Supported Browsers

- **Chrome** (but see note above)
- **Firefox** (but see note above)
- **Safari**
- **Edge** (only mjpeg stream)

### RSTP server

Currently only H264 RTSP streams are supported from mediamtx sidecar container

## Usage

Set MTX_PATH environment default value in common.env :
  - "cam": binary server will use configuration file for RPI Camera (it must be connected to the Raspberry Pi camera socket
  - "webcam": environment to set the source as the USB WebCam (/dev/video0)
Force switch to any MTX_PATH source:
`./config_mtx.sh [cam|webcam]`

## Node Package Manager

  This project depends on npmjs [balena-cloud-apps](https://www.npmjs.com/package/balena-cloud-apps). Please call
  `npm install balena-cloud-apps && npm update`
  whenever the system complains about `balena_deploy` not found.
After npm install succeeded, HuewizPi can be dbuilt and optionally deployed to the device

### Updating Balena templates

When you make changes to `docker*.template` files and environment `*.env` files, you can apply changes that the CPU architecture depends on. To do so, run
deployment scripts `update-templates.sh`

A new service image can be build
- Check values in `${BALENA_ARCH}.env`
  
| Node Machine   | `BALENA_MACHINE_NAME` | `BALENA_ARCH` |
| ------------ | -------------------- | ------------- |
| Raspberry Pi 3 | raspberrypi3           | armhf |
| Raspberry Pi 4 | raspberrypi3-64       | aarch64 |
| Mini PC        | intel-nuc             | x86_64 |

### Making changes
Open a new fixture branch:
`./git-fix-issue.sh <issue #>`
After switched to the new branch, edit and make changes you need, git add and commit them to the git tree.
Close issue after a successful pull request:
`./git-fix-issue-close.sh <issue #>`
It will delete the fixture branch locally and checkout main/master branch

### Deploy to Balena Cloud

Update balena apps after committing changes `git commit -a && git push`
  `. deploy.sh`
- Select 1:armhf, 2:aarch64 or 3:x86_64 as the target machine CPU
- You choose to build FROM a balenalib base image as set in Dockerfile.template, then type `0` or `CTRL-C` to exit the script
- All template data filters copy to Dockerfile.aarch64, Dockerfile.armhf and Dockerfile.x86_64


