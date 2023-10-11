podman-compose -f docker-compose-daily-v3-test.yml --podman-build-args "--cpuset-cpus=2-3 -m=1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
#podman-compose -f docker-compose-io-v3-test.yml --podman-build-args "-m 1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
