#podman-compose -f docker-compose-io-v3-test.yml --podman-build-args "--cpus 2 -m=1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
#podman-compose -f docker-compose-io-v3-test.yml --podman-build-args "-m 1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
podman-compose -f docker-compose-io-v3-test.yml --podman-build-args "--cpuset-cpus=6,7 -m 1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
#
#
#podman-compose -f docker-compose-io-v3-test.yml --podman-build-args "--cpu-quota=200000 -m 1g --cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --no-cache" build
#--cpu-quota=200000
