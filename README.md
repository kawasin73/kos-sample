# kos-sample

[30日でできる! OS自作入門](https://www.amazon.co.jp/gp/product/B00IR1HYI0) を参考にした OS を作る

コンパイル環境は macOS です。

## Environments

- macOS : 10.14.5 (mojave)
- Macbook Pro 13 inch

install QEMU by Homebrew

```bash
$ brew install qemu
```

## How to Start ?

```bash
# ダウンロード
$ git clone git@github.com:kawasin73/kos-sample.git
$ cd kos-sample

# コンパイル + 起動
$ make run_full

# 起動
$ make run

# ここのアプリケーションだけを起動する場合
$ cd invader/ && make run_full
```

## 参考

- https://github.com/tatsumack/30nichideosjisaku

## LICENSE

MIT

元の OS は、[KL-01](https://osdn.net/projects/hige/docs/license/ja/1/license.html) で公開されている。
