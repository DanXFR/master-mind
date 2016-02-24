# Introduction #

Cryptanalysis (from the Greek _kryptós_, "hidden", and _analýein_, "to loosen" or "to untie") is the study of methods for obtaining the meaning of encrypted information, without access to the secret information which is normally required to do so.

# Classical Cryptanalysis #

  * Frequency Analysis
  * Index of Coincidence
  * Kasiski Examination

# Modern Cryptanalysis #

> ## Assumption ##

> [Kerckhoffs' Principle](http://en.wikipedia.org/wiki/Kerckhoffs'_principle) (aka Kerckhoffs' Assumption, Axiom or Law) was stated by Auguste Kerckhoffs in the 19th century: A cryptosystem should be secure even if everything about the system, except the key, is public knowledge.

> Kerckhoffs' principle was reformulated (perhaps independently) by Claude Shannon as "The enemy knows the system.", which is called Shannon's Maxim.

> ## Attack Models ##

  * Ciphertext-Only
  * Known-Plaintext
  * Chosen-Ciphertext
  * Chosen-Plaintext
  * Adaptive Chosen-Ciphertext
  * Adaptive Chosen-Plaintext
  * Related-Key

> ## Cryptanalysis Methods ##

  * Brute-force Attack
  * Boomerang Attack
  * Davies' Attack
  * Differential Cryptanalysis
  * Impossible Differential Cryptanalysis
  * Integral Cryptanalysis
  * Linear Cryptanalysis
  * Meet-in-the-middle Attack
  * Mod-N Cryptanalysis
  * Slide Attack
  * XSL Attack

# Classifying Success in Cryptanalysis #

> Lars Knudsen (1998) classified various types of attack on block ciphers according to the amount and quality of secret information that was discovered:

  * Total Break: The attacker deduces the secret key.
  * Global Deduction: The attacker discovers a functionally equivalent algorithm for encryption and decryption, but without learning the key.
  * Instance (Local) Deduction: The attacker discovers additional plaintexts (or ciphertexts) not previously known.
  * Information Deduction: The attacker gains some Shannon information about plaintexts (or ciphertexts) not previously known.
  * Distinguishing Algorithm: The attacker can distinguish the cipher from a random permutation.

> Similar considerations apply to attacks on other types of cryptographic algorithm.

# References #

  * [Cryptanalysis Page on Wikipedia](http://en.wikipedia.org/wiki/Cryptanalysis)