# Linux C 编程一站式学习（One-Stop Linux C Programming）

本仓库以 [akaedu/book 的 `gh-pages` 分支](https://github.com/akaedu/book/tree/gh-pages)为原书基线，保留原始 Git 历史；基线提交是 `9a3baabb681acbd1611a8798ccb32b3f80022f97`。`index.html`、`styles.css` 和 `images/` 组成与[原站](https://akaedu.github.io/book/index.html)相同的静态页面。已发布的[在线镜像](https://xingshuozhu1998.github.io/linux-c-one-stop/index.html)保留原站排版和图片。首页只新增[现代阅读指南与勘误](modern.html)入口；原作者前言与版权说明保留在[原书首页](index.html)及[GNU 自由文档许可证](apb.html)。

## 阅读与进入容器

本机已从现有的 `ubuntu:24.04` 镜像构建 `zhuxs_linux_c:ubuntu24.04`，并创建同名常驻容器。本机书页地址：<http://127.0.0.1:18765/index.html>；公开书页地址：<https://xingshuozhu1998.github.io/linux-c-one-stop/index.html>。

```sh
docker exec -it zhuxs_linux_c bash
pwd
echo "$CODEX_HOME"
```

宿主机的整个 `/data/zhuxs/cs_learning/` 映射到容器的同一路径；进入容器时默认位于 `/data/zhuxs/cs_learning/00_linux_c_one_shot_learning`。可在这里创建 `practice/` 写练习，文件会直接出现在主机目录。宿主机和容器的 `~/.bashrc` 都设置 `CODEX_HOME=/data/zhuxs/cs_learning/codex_bk/.codex`；[OpenAI Docs](https://learn.chatgpt.com/docs/config-file/config-advanced)说明本地会话历史保存在 `CODEX_HOME` 下，因此新启动的 Codex CLI 将使用同一份历史。现有 Codex 进程要重新启动才会读取新环境。容器中的 GDB 可调试子进程；HTTP 服务由容器主进程提供。访问端口只绑定主机的 `127.0.0.1`；如果从另一台电脑经 SSH 连接，可用 `ssh -L 18765:127.0.0.1:18765 <主机>` 转发后在本机浏览器打开上述地址。

如果以后需要重建容器，先确认练习文件都在绑定的工作目录，然后在仓库目录执行：

```sh
docker build -t zhuxs_linux_c:ubuntu24.04 .
docker stop zhuxs_linux_c
docker rm zhuxs_linux_c
docker run -d --name zhuxs_linux_c --restart unless-stopped \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -p 127.0.0.1:18765:8765 \
  --mount type=bind,src=/data/zhuxs/cs_learning,dst=/data/zhuxs/cs_learning \
  -w /data/zhuxs/cs_learning/00_linux_c_one_shot_learning zhuxs_linux_c:ubuntu24.04
printf 'protocol=https\nhost=github.com\n\n' | git credential fill | \
  docker exec -i zhuxs_linux_c git credential approve
```

最后一条命令在宿主机执行：它把宿主机已保存的 GitHub 凭证经标准输入写入新容器的 `store` 凭证助手，不把令牌放进 Docker 镜像或本仓库。Dockerfile 还设置了容器的 Git HTTP/HTTPS 代理 `http://192.168.10.101:17890` 和 `CODEX_HOME`；Codex CLI 由你进入容器后自行安装。现有的 Codex 登录和会话文件来自共享目录，不打包进镜像。

## 学习与修订依据

先读[现代阅读指南](modern.html)建立 C 标准 → 编译链 → ABI/ELF → 运行库/内核 → 容器边界的心智模型，再顺原书章节做实验。工具链选择、官方来源和旧版内容的适用范围见[工具链调研](docs/toolchain-research.md)。本容器当前实测 GCC 13.3、Clang 18.1、glibc 2.39、GDB 15.1、Make 4.3、CMake 3.28.3；基础练习显式用 `-std=c17`。GCC 13 不接受 `-std=c23`，可用 `-std=c2x` 观察部分新特性；Clang 18 接受 `-std=c23`。

原书包含 219 个 HTML 页面和 166 张图片。已检查原书的 4495 个站内文件引用，目标文件无缺失；原站另有 279 处页内锚点失效，当前修订版仍有 278 处，详情见[验证范围](modern.html#limits)。已直接修订可核实的概念错误及部分旧工具命令，清单在[勘误表](modern.html#errata)。这不等于全书所有代码和历史断言均已逐项证实；读到新疑点时，应记录原文、所用标准与工具版本、最小复现和官方依据，再改对应书页。

## Git 来源与个人 Fork

个人 Fork 位于 [xingshuozhu1998/linux-c-one-stop](https://github.com/xingshuozhu1998/linux-c-one-stop)。当前仓库的 `upstream` 指向原作者仓库，`origin` 指向个人 Fork，`book-original` 指向未修订的原书基线，`main` 用于本项目修订。GitHub Pages 已设置为从 `main` 根目录发布，在线镜像实测能返回与本地相同的首页、指南、样式、图片和已修订章节字节内容。

## 日常修改并同步到 GitHub 与书站

容器与宿主机中的项目路径相同；在任一处编辑，另一处立即可见。宿主机和当前容器都已配置 GitHub 凭证，以下命令可在任一环境执行。开始一次新修改前，如果 `git status --short` 没有输出，可以先拉取远端更新：

```sh
cd /data/zhuxs/cs_learning/00_linux_c_one_shot_learning
git status --short
git pull --ff-only origin main
```

修改书页或笔记后，先在本机书站 <http://127.0.0.1:18765/index.html> 查看效果，再检查改动。下面用 `docs/c-notes.md` 举例；实际操作时把文件名换成这次修改的文件，避免把练习产生的可执行文件一起提交：

```sh
git status --short
git diff --check
git add docs/c-notes.md
git diff --cached --check
git diff --cached --stat
git diff --cached -- docs/c-notes.md
git commit -m "补充 C 语言学习笔记"
git push origin main
git status --short --branch
```

推送成功后，修改会立即出现在 [GitHub 仓库](https://github.com/xingshuozhu1998/linux-c-one-stop)，GitHub Pages 会从 `main` 根目录自动重新发布到[公开书站](https://xingshuozhu1998.github.io/linux-c-one-stop/index.html)。可到 [Actions 页面](https://github.com/xingshuozhu1998/linux-c-one-stop/actions)检查 `pages build and deployment` 是否成功；发布可能需要几分钟，[GitHub 文档](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)说明最长可能约 10 分钟。

`docs/*.md` 笔记适合在 GitHub 仓库中阅读。本书站用 `.nojekyll` 直接发布静态文件，Markdown 不会自动变成与原书同样排版的网页；若想让笔记在书站中供读者浏览，可把内容写进 `modern.html`，或新建引用 `styles.css` 的 HTML 页，并在首页或现代指南中添加链接，然后按上述命令提交相关文件。
