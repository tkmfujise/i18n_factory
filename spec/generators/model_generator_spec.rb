require 'generator_spec'
require 'generators/model_generator'

# RSpec.describe I18nFactory::Generators::ModelGenerator, type: :generator do
RSpec.describe Rails::Generators::ModelGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  subject { run_generator arguments }
  before { prepare_destination }
  let(:arguments) { %w(Post title content:text) }

  let(:locale_dir) { Pathname(destination_root).join('config/locales') }

  context 'default' do
    it 'create en.yml' do
      expect{ subject }.not_to raise_error
      expect(locale_dir.children.count).to eq 1
      expect(locale_dir.join('post').children.count).to eq 1
      assert_file 'config/locales/post/en.yml', <<~YAML
        en:
          activerecord:
            models:
              post: Post
            attributes:
              post:
                title:   Title
                content: Content
      YAML
    end
  end


  context 'if config.i18n.default_locale defined ja' do
    before { allow(I18n).to receive(:locale).and_return(:ja) }   

    it 'create ja.yml' do
      expect{ subject }.not_to raise_error
      expect(locale_dir.children.count).to eq 1
      expect(locale_dir.join('post').children.count).to eq 1
      assert_file 'config/locales/post/ja.yml', <<~YAML
        ja:
          activerecord:
            models:
              post: Post
            attributes:
              post:
                title:   Title
                content: Content
      YAML
    end
  end


  context 'if set multiple locales' do
    before {
      I18nFactory.configure do |factory|
        factory.locales = [:ja, 'zh-TW']
      end
    }
    after { I18nFactory.config.locales = [] }

    it 'create ja.yml and zh-TW.yml' do
      expect{ subject }.not_to raise_error
      expect(locale_dir.children.count).to eq 1
      expect(locale_dir.join('post').children.count).to eq 2
      assert_file 'config/locales/post/ja.yml', <<~YAML
        ja:
          activerecord:
            models:
              post: Post
            attributes:
              post:
                title:   Title
                content: Content
      YAML
      assert_file 'config/locales/post/zh-TW.yml', <<~YAML
        zh-TW:
          activerecord:
            models:
              post: Post
            attributes:
              post:
                title:   Title
                content: Content
      YAML
    end
  end

  context 'if namespaced model given' do
    shared_examples 'works' do
      it 'create en.yml' do
        expect{ subject }.not_to raise_error
        expect(locale_dir.join('foo/bar').children.count).to eq 1
        assert_file 'config/locales/foo/bar/en.yml', <<~YAML
          en:
            activerecord:
              models:
                foo/bar: Foo::Bar
              attributes:
                foo/bar:
                  name: Name
        YAML
      end
    end

    context 'slash' do
      let(:arguments) { %w(foo/bar name) }
      include_examples 'works'
    end
    
    context 'colon' do
      let(:arguments) { %w(Foo::Bar name) }
      include_examples 'works'
    end
  end
end
