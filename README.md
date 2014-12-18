update_name
===========
[![Code Climate](https://img.shields.io/codeclimate/github/Gomasy/update_name.svg?style=flat)](https://codeclimate.com/github/Gomasy/update_name)
[![Dependency Status](https://img.shields.io/gemnasium/Gomasy/update_name.svg?style=flat)](https://gemnasium.com/gomashio/update_name)

## これなに？
update_name するプログラムです。Ruby で書いてます。

## いれかた
前提条件として、Ruby 1.9 以上が必要です。  
インストールされていない場合は予め導入して置いてください。
```sh
$ git clone git@github.com:Gomasy/update_name.git
```

## 実行方法
```sh
$ chmod +x main.rb
$ nohup ./main.rb &> /dev/null &
```

## 設定について
テンプレートファイル (keys.yml.example) を keys.yml にリネームし、任意のエディタで開き各トークンを記述して下さい。

## Require Gems
* twitter >= 5.7.0

## LICENSE
Copryright 2013-2014, Gomasy  
Licensed MIT  
http://opensource.org/licenses/mit-license.php
