use {
    crate::auth::{
        did,
        jwt::{claims_are_within_validity_window, JwtClaims, JwtVerifierByIssuer},
    },
    serde::{Deserialize, Serialize},
};

pub mod register;
pub mod resolve;
pub mod unregister;

#[derive(Debug, Serialize, Deserialize)]
pub struct InviteKeyClaims {
    aud: String, // keys server url used for registering
    exp: usize,  // timestamp when jwt must expire TODO: Should be 1 hour
    iat: usize,  // timestamp when jwt was issued

    /// Public identity key in form of did:key according to the [Ed25519][1]
    ///
    /// [1]: https://w3c-ccg.github.io/did-method-key/#ed25519-x25519
    iss: String,

    /// Public key for chat invite key in form of did:key according to the
    /// [X25519][1]
    ///
    /// [1]: https://w3c-ccg.github.io/did-method-key/#x25519
    sub: String,

    pkh: String, // corresponding blockchain account (did:pkh)
}

impl JwtClaims for InviteKeyClaims {
    fn is_valid(&self) -> bool {
        // TODO: Add validation:
        // aud must be equal this dns?
        // iss must be valid did:key
        // pkh must be valid did:pkh

        did::validate_x25519(&self.sub) && claims_are_within_validity_window(self.exp, self.iat)
    }
}

impl JwtVerifierByIssuer for InviteKeyClaims {
    fn get_iss(&self) -> &str {
        &self.iss
    }
}

#[cfg(test)]
mod test_claims_validation {
    use {
        super::{InviteKeyClaims, JwtClaims as _},
        std::time::{SystemTime, UNIX_EPOCH},
    };

    fn now_secs() -> usize {
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs() as usize
    }

    fn default() -> InviteKeyClaims {
        let now = now_secs();
        InviteKeyClaims {
            aud: String::new(),
            exp: now + 3600,
            iat: now.saturating_sub(1),
            iss: String::new(),
            sub: String::new(),
            pkh: String::new(),
        }
    }

    #[test]
    fn fails_on_incorrect_claims() {
        let mut claims = default();
        assert!(!claims.is_valid());

        claims.sub = "ababagalamaga".to_string();
        assert!(!claims.is_valid());

        claims.sub = "did:key:zQ3shokFTS3brHcDQrn82RUDfCZESWL1ZdCEJwekUDPQiYBme".to_string();
        assert!(!claims.is_valid());

        claims.sub = "did:abc".to_string();
        assert!(!claims.is_valid());
    }

    #[test]
    fn succeeds_on_correct_claims() {
        let mut claims = default();

        claims.sub = "did:key:z6LSeu9HkTHSfLLeUs2nnzUSNedgDUevfNQgQjQC23ZCit6F".to_string();
        assert!(claims.is_valid());

        claims.sub = "did:key:z6LStiZsmxiK4odS4Sb6JmdRFuJ6e1SYP157gtiCyJKfrYha".to_string();
        assert!(claims.is_valid());

        claims.sub = "did:key:z6LSoMdmJz2Djah2P4L9taDmtqeJ6wwd2HhKZvNToBmvaczQ".to_string();
        assert!(claims.is_valid());
    }

    #[test]
    fn fails_on_expired_exp() {
        let mut claims = default();
        claims.sub = "did:key:z6LSeu9HkTHSfLLeUs2nnzUSNedgDUevfNQgQjQC23ZCit6F".to_string();
        assert!(claims.is_valid());

        claims.exp = now_secs().saturating_sub(120);
        assert!(!claims.is_valid());
    }
}
