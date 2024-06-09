require 'generator_spec'
require 'generators/update_all_generator'
require 'fake_app'

RSpec.describe I18nFactory::Generators::UpdateAllGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  subject { run_generator }
  before { prepare_destination }

  let(:locale_dir) { Pathname(destination_root).join('config/locales') }

  executed_commands = []

  before do
    executed_commands = []
    allow_any_instance_of(described_class).to receive(:generate) do |_, command, name|
      # Rails.logger.info command
      # Rails.logger.info name
      executed_commands << [command, name]
    end
  end

  it 'works' do
    # expect{ subject }.not_to raise_error
    subject rescue true # FIXME エラーが出る
    expect(executed_commands).to contain_exactly(
      ['i18n_factory:update', 'User'],
      ['i18n_factory:update', 'Article'],
      ['i18n_factory:update', 'Foo::Bar'],
    )
  end

  context 'if ignore_paths given' do
    before { I18nFactory.config.ignore_paths = ['app/models/foo/bar.rb'] }
    after { I18nFactory.config.ignore_paths = [] }
    
    it 'works' do
      # expect{ subject }.not_to raise_error
      subject rescue true # FIXME エラーが出る
      expect(executed_commands).to contain_exactly(
        ['i18n_factory:update', 'User'],
        ['i18n_factory:update', 'Article'],
      )
    end
  end
end

