Git 单文件上传大小限制

git大小限制。 git的默认提交文件大小，网上都说是1M，只需要设置 git config --global http.postBuffer 524288000 把git的允许提交大小设为500M即可。
git config --global http.postBuffer 1242880
