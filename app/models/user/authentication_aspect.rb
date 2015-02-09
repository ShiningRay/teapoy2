module User::AuthenticationAspect
  extend ActiveSupport::Concern
  class MyCryptoProvider
    # Turns your raw password into a Sha1 hash.
    def self.encrypt(*tokens)
      digest = Digest::SHA1.hexdigest("--#{tokens[1]}--#{tokens[0]}--")
      digest
    end

    # Does the crypted password match the tokens? Uses the same tokens that were used to encrypt.
    def self.matches?(crypted, *tokens)
      encrypt(*tokens) == crypted
    end
  end

  included do
    acts_as_authentic do |c|
      #    c.transition_from_crypto_providers= ::MyCryptoProvider
      #    c.crypto_provider = Authlogic::CryptoProviders::Sha512
      c.crypto_provider = MyCryptoProvider
      c.disable_perishable_token_maintenance true
      c.validate_login_field false
    end

    has_many :persistence_tokens do
      def ==(token)
        where(token: token).first
      end
    end
  end

  def reset_persistence_token!
    # self.persistence_token = Authlogic::Random.hex_token
    super
    persistence_tokens.delete_all
  end

  def find_by_persistence_token(token)
    where(persistence_token: token).first or PersistenceToken.where(token: token).first.try(:user)
  end
end
