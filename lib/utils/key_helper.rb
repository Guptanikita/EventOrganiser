class KeyHelper
    def self.generate_key(clazz, key_type, key_length =20)
      loop do
        token = SecureRandom.hex(key_length).tr('+/=lIO0', 'alcxqrt')
        if clazz.where(key_type => token).count == 0
          break token
        end
      end
    end
end