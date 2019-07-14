# coding: utf-8
opus = Organization.where(name: "Opus Logica, Inc").first_or_create(nicknames_attributes: [{ nickname: "OPUS" }])
bfox = User.lookup("bfox@opuslogica.com") ||
       User.create(person_attributes: { email: "bfox@opuslogica.com", name: "Brian Jhan Fox",
                                        address: "901 Olive St., Santa Barbara, CA, 93101",
                                        phone: "805.555.8642" },
                   organization: opus)
