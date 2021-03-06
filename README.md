# saitensou-image
This is the repository to build the image used in the saitensou system.

## Introduction
This image serve as an image that hosts a RTMP server.

## installation
1. adapt the configs
    > `$ code .`
1. build the image using your image building software
    > `$ podman build . -t saitensou_rtmp`
1. then your image is built!
1. run the image using docker, or deploy to the container
    > `$ podman run -p {STREAM_PORT}:80 -p {RTMP_PORT}:1935 saitensou_rtmp`

## usage
This project currently copies the config from the nginx official repo, therefore it remains default for everything.
1. basic streaming
    - Basically, the image is configured to receieve anything from the port `RTMP_PORT`. therefore you can stream the playable (OBS or file) directly to the following address:
        > rtmp://{SERVER_ADDRESS}:{RTMP_PORT}/hls/{APPLICATION_NAME}
        - sample file streaming command:
            > `ffmpeg -re -ss {START_TIME} -i {FILE_LOCATION} -vcodec copy -c:a aac -b:a 160k -ar 44100 -strict -2  -f flv rtmp://{SERVER_ADDRESS}:{RTMP_PORT}/hls/{APPLICATION_NAME}`
    - Then the stream can be viewed in the following site:
        > http://{SERVER_ADDRESS}:{STREAM_PORT}/hls/{APPLICATION_NAME}.m3u8


## Timeline
The high level progress of the project is as follows:
- [X] Built a minial working image
    - [ ] (Documentation)
- [ ] Configure the config to allow more configuration
    - [ ] (Documentation)
- [X] Push to AWS ECR
    - [ ] (Documentation)
- [X] Test with AWS ECS
    - [ ] (Documentation)
- [ ] Push to AWS EKS
    - [ ] (Documentation)
- [ ] Add config to expose as service
    - [ ] (Documentation)
- [ ] Add config to make deployment
    - [ ] (Documentation)
- [ ] Make it as a CDK/CloudFormation Template
    - [ ] (Documentation)
- [ ] Add front-end application to interact with the service
    - [ ] (Documentation)




## Reference
- [Nginx RTMP module](https://github.com/arut/nginx-rtmp-module)
- [Nginx RTMP module local setup tutorial](https://www.nginx.com/blog/video-streaming-for-remote-learning-with-nginx/)
