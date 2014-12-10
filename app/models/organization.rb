class Organization < ActiveRecord::Base
  def avatar_url
    if self.avatar
      "https://#{ENV['ACCOUNTS_BUCKET']}.s3.amazonaws.com/uploads/organization/avatar/#{self.id}/square_#{self.avatar}"
    else
      "http://i.imgur.com/lsAFCHL.jpg"
    end
  end
end
