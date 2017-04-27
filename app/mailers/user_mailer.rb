class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("acc_activation")
  end

  def password_reset
    @greeting = t "user_mailer.account_activation.hi"
    mail to: "to@example.org"
  end
end
