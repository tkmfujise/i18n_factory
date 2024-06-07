require 'generator_spec'
require 'generators/model_generator'

# RSpec.describe I18nFactory::Generators::ModelGenerator, type: :generator do
RSpec.describe Rails::Generators::ModelGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  subject { run_generator %w(Post title content:text) }
  before { prepare_destination }

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
                title: Title
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
                title: Title
                content: Content
      YAML
    end
  end
end
