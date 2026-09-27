# Linux C 编程一站式学习：本地镜像与现代实操

本仓库以 [akaedu/book 的 `gh-pages` 分支](https://github.com/akaedu/book/tree/gh-pages)为原书基线，保留原始 Git 历史；基线提交是 `9a3baabb681acbd1611a8798ccb32b3f80022f97`。`index.html`、`styles.css` 和 `images/` 组成与[原站](https://akaedu.github.io/book/index.html)相同的静态页面。首页只新增[现代阅读指南与勘误](modern.html)入口；原作者前言与版权说明保留在[原书首页](index.html)及[GNU 自由文档许可证](apb.html)。

## 阅读与进入容器

本机已从现有的 `ubuntu:24.04` 镜像构建 `zhuxs_linux_c:ubuntu24.04`，并创建同名常驻容器。书页地址：<http://127.0.0.1:18765/index.html>。

```sh
docker exec -it zhuxs_linux_c bash
cd /workspace
```

`/workspace` 绑定到 `/data/zhuxs/cs_learning/00_linux_c_one_shot_learning`。可在这里创建 `practice/` 写练习，文件会直接出现在主机目录。容器中的 GDB 可调试子进程；HTTP 服务由容器主进程提供。访问端口只绑定主机的 `127.0.0.1`；如果从另一台电脑经 SSH 连接，可用 `ssh -L 18765:127.0.0.1:18765 <主机>` 转发后在本机浏览器打开上述地址。

如果以后需要重建容器，先确认练习文件都在绑定的工作目录，然后在仓库目录执行：

```sh
docker build -t zhuxs_linux_c:ubuntu24.04 .
docker stop zhuxs_linux_c
docker rm zhuxs_linux_c
docker run -d --name zhuxs_linux_c --restart unless-stopped \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -p 127.0.0.1:18765:8765 \
  --mount type=bind,src=/data/zhuxs/cs_learning/00_linux_c_one_shot_learning,dst=/workspace \
  -w /workspace zhuxs_linux_c:ubuntu24.04
```

## 学习与修订依据

先读[现代阅读指南](modern.html)建立 C 标准 → 编译链 → ABI/ELF → 运行库/内核 → 容器边界的心智模型，再顺原书章节做实验。工具链选择、官方来源和旧版内容的适用范围见[工具链调研](docs/toolchain-research.md)。本容器当前实测 GCC 13.3、Clang 18.1、glibc 2.39、GDB 15.1、Make 4.3、CMake 3.28.3；基础练习显式用 `-std=c17`。GCC 13 不接受 `-std=c23`，可用 `-std=c2x` 观察部分新特性；Clang 18 接受 `-std=c23`。

原书包含 219 个 HTML 页面和 166 张图片。已检查原书的 4495 个站内文件引用，目标文件无缺失；原站另有 279 处页内锚点失效，当前修订版仍有 278 处，详情见[验证范围](modern.html#limits)。已直接修订可核实的概念错误及部分旧工具命令，清单在[勘误表](modern.html#errata)。这不等于全书所有代码和历史断言均已逐项证实；读到新疑点时，应记录原文、所用标准与工具版本、最小复现和官方依据，再改对应书页。

## Git 来源与个人 Fork

当前仓库的 `upstream` 指向原作者仓库，`book-original` 指向未修订的原书基线，`main` 用于本项目修订。Fork 到个人 GitHub 后，把个人仓库设为 `origin` 并推送 `main` 即可；推送前先核对当前 GitHub 账号和目标仓库地址。GitHub Pages 若从 `main` 的根目录发布，可直接访问相同的静态页面。
