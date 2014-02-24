update_name
===========
[![Dependency Status](https://gemnasium.com/gomashio/update_name.png)](https://gemnasium.com/gomashio/update_name)

## これなに？
update_nameするプログラムです。Rubyで書いてます。

## いれかた
前提条件として、Ruby 1.9以上が必要です。  
インストールされていない場合は予め導入して置いてください。
```sh
$ git clone https://github.com/gomashio/update_name.git
$ cd ./update_name
$ mv keys.yml.example keys.yml

// キー諸所を記述
$ vim keys.yml
```

## 実行方法
```sh
$ chmod +x main.rb
$ nohup ./main.rb &> /dev/null &
```

## Require Gems
* twitter >= 5.7.0

## LICENSE
Copryright 2013-2014, Gomashio  
Licensed MIT  
http://opensource.org/licenses/mit-license.php
