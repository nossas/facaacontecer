# coding: utf-8
class Notifications::InviteMailer < ActionMailer::Base

  default from: "Rodrigo <rodrigo@meurio.org.br>", reply_to: "rodrigo@meurio.org.br"

  default_url_options[:host] = 'apoie.nossascidades.org'

  def created_guest(user_id, host_id)
    object(user_id)
    inviter(host_id)

    mail(
      # The emails goes to the person who INVITED
      to: @inviter.email,
      subject: "Você ganhou uma camiseta da Rede Meu Rio!"
    )
  end

  def object(id)
    @user = User.find_by(id: id)
  end

  def inviter(id)
    @inviter = User.find_by(id: id)
  end
end
