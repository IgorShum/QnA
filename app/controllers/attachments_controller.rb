class AttachmentsController < ApplicationController
  before_action :find_attachment, only: :destroy

  def destroy
    return head :forbidden unless current_user.author_of?(@attchment.record)

    @attchment.purge
  end

  private

  def find_attachment
    @attchment = ActiveStorage::Attachment.find(params[:id])
  end
end
