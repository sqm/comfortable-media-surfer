# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'comfortable_media_surfer/version'

Gem::Specification.new do |spec|
  spec.name          = 'comfortable_media_surfer'
  spec.version       = ComfortableMediaSurfer::VERSION
  spec.authors       = ['Oleg Khabarov', 'Andrew vonderLuft', 'ShakaCode']
  spec.email         = ['justin@shakacode.com']
  spec.homepage      = 'https://github.com/shakacode/comfortable-media-surfer'
  spec.summary       = 'Rails 7.0+ CMS Engine'
  spec.description   = 'ComfortableMediaSurfer is a powerful Rails 7.0+ CMS Engine'
  spec.license       = 'MIT'

  spec.post_install_message = 'Please run rake comfy:compile_assets to compile assets.'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|doc)/})
  end

  # Add the asset build artifacts to the gem. The official version of Comfy doesn't package these
  # and instead depends on running a Rake task after installation; we're running that task as a
  # part of publishing the gem to our package registry (see `.github/workflows/gem-push.yml`).
  spec.files += Dir.glob("app/assets/builds/**/*")

  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'active_link_to',       '~> 1.0',   '>= 1.0.5'
  spec.add_dependency 'comfy_bootstrap_form', '~> 4.0',   '>= 4.0.0'
  spec.add_dependency 'haml-rails',           '>= 2.1', '< 4.0'
  spec.add_dependency 'image_processing',     '~> 1.2',   '>= 1.12.2'
  spec.add_dependency 'kaminari',             '~> 1.2',   '>= 1.2.2'
  spec.add_dependency 'kramdown',             '~> 2.4',   '>= 2.4.0'
  spec.add_dependency 'mimemagic',            '~> 0.4',   '>= 0.4.3'
  spec.add_dependency 'mini_magick',          '>= 4.12', '< 6.0'
  spec.add_dependency 'rails',                '>= 7.0.0'
  spec.add_dependency 'rails-i18n',           '>= 6.0.0'
end
