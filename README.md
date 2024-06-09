# I18nFactory

## Installation

```rb
gem 'i18n_factory', group: :development
```

## Usage

If you run `rails g model` command, an i18n file which is described for the model will be automatically created to `config/locales/<model_name>/<your_locale>.yml`.

e.g.)

```
$ bin/rails g model Post title content:text 
```

will also create `config/locales/post/en.yml` after the model files creation.

```yml
en:
  activerecord:
    models:
      post: Post  
    attributes:
      post:
        title:   Title
        content: Content
```

### How to update i18n files

Even if you already created the model, you can generate an i18n file.

Try to run the next command. It will update or create an i18n file, which got the model columns from the database schema.

```
$ bin/rails g i18n_factory:update ModelName
```
or
```
$ bin/rails g i18n_factory:update_all
```

> [!WARNING]
> 既存のロケールファイルがある場合はそれを壊さないよう抜けている列のみをマージするように処理していますが、もしかしたらうまく動かない場合があるかもしれません。
> うまく動かないパターンがあれば、Issue で教えていただければと思います。


**i18n_factory** find your application locale from `I18n.locale`. 

If you defined locale to `ja` in `config/application.rb`.

```rb
module YourApplicationName
  class Application < Rails::Application
    # ...
    config.i18n.default_locale = :ja
  end
end
```

It will create i18n files as `config/locales/xxx/ja.yml`.


#### How to set multiple locales

Try to edit `config/environments/development.rb`
```rb
Rails.application.configure do
  # ...
  config.after_initialize do
    I18nFactory.configure do |factory|
      factory.locales = [:ja, 'zh-TW']
    end
  end
end
```

It will create i18n files as 
* `config/locales/xxx/ja.yml`
* `config/locales/xxx/zh-TW.yml`


#### How to avoid a specific file from update_all

If you defined `I18nFactory.config.ignore_paths`, it will skip loading the files to create locale files when `rails g i18n_factory:update_all`.

```rb
I18nFactory.configure do |factory|
  factory.ignore_paths = ['app/models/foo/bar.rb']
end
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
