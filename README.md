# I18nFactory


## Installation

```
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
        title: Title
        content: Content
```

### How to update i18n files

Even if you already created the model, you can generate an i18n file.

Please try to run the next command. It will update or create an i18n file, which got the model columns from the database schema.

```
$ bin/rails g i18n_factory:update ModelName
```
or
```
$ bin/rails g i18n_factory:update_all
```


### How to set locales

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


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
