require 'spec_helper'

describe Gitlab::ImportExport::AvatarRestorer do
  include UploadHelpers

  let(:shared) { Gitlab::ImportExport::Shared.new(relative_path: 'test') }
  let(:project) { create(:empty_project) }

  before do
    allow_any_instance_of(described_class).to receive(:avatar_export_file)
                                                .and_return(uploaded_image_temp_path)
  end

  after do
    project.remove_avatar!
  end

  it 'restores a project avatar' do
    expect(described_class.new(project: project, shared: shared).restore).to be true
  end

  it 'saves the avatar into the project' do
    described_class.new(project: project, shared: shared).restore

    expect(project.reload.avatar.file.exists?).to be true
  end
end
