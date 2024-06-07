require 'generator_spec'
require 'generators/update_generator'
require 'fake_app'

RSpec.describe I18nFactory::Generators::UpdateGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  subject { run_generator [model_name] }
  before { prepare_destination }

  let(:locale_dir) { Pathname(destination_root).join('config/locales') }

  context 'default' do
    context 'if no files' do
      let(:model_name) { 'Article' }
      
      it 'create en.yml' do
        expect{ subject }.not_to raise_error
        expect(locale_dir.children.count).to eq 1
        expect(locale_dir.join('article').children.count).to eq 1
        assert_file 'config/locales/article/en.yml', <<~YAML
          en:
            activerecord:
              models:
                article: Article
              attributes:
                article:
                  title: Title
                  content: Content
                  user_id: UserId
        YAML
      end
    end

    context 'if namespaced model' do
      let(:model_name) { 'Foo::Bar' }
      
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
  end
end


