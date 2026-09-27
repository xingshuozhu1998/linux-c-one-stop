FROM ubuntu:24.04

# 保留原书使用的 GNU 工具，并补齐现代 C、调试和 32 位旧例所需的工具。
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc-multilib libc6-dev-i386 clang clang-format lld \
    gdb binutils cmake ninja-build pkg-config \
    strace valgrind file git python3 iproute2 man-db manpages-dev \
    less vim-tiny ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
EXPOSE 8765
CMD ["python3", "-m", "http.server", "8765", "--bind", "0.0.0.0", "--directory", "/workspace"]
