FROM ubuntu:24.04

# 保留原书使用的 GNU 工具，并补齐现代 C、调试和 32 位旧例所需的工具。
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc-multilib libc6-dev-i386 clang clang-format lld \
    gdb binutils cmake ninja-build pkg-config \
    strace valgrind file git python3 iproute2 man-db manpages-dev \
    less vim-tiny ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 账号设置可随镜像重建；GitHub 令牌只在容器运行后由宿主机凭证助手传入。
RUN git config --global user.name xingshuozhu1998 \
    && git config --global user.email 2676285858@qq.com \
    && git config --global credential.helper store \
    && git config --global http.proxy http://192.168.10.101:17890 \
    && git config --global https.proxy http://192.168.10.101:17890

WORKDIR /data/zhuxs/cs_learning/00_linux_c_one_shot_learning
EXPOSE 8765
CMD ["python3", "-m", "http.server", "8765", "--bind", "0.0.0.0", "--directory", "/data/zhuxs/cs_learning/00_linux_c_one_shot_learning"]
