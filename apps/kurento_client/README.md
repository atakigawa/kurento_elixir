Kurento Client
==

Backend server that communicates with KMS.
Aims to implement Kurento Protocol described [here](https://www.kurento.org/docs/current/mastering/kurento_protocol.html) in Elixir. 

It basically consists of:
- Core: handles sending/receiving message with KMS
- MediaObjects: interfaces that are defined in KMS to manipulate media stream

MediaObjects part is mostly just derived from definition files that can be found in the following KMS repositories.
See [document](https://www.kurento.org/docs/current/mastering/kurento_protocol.html#kurento-api) for details.
- [KMS core](https://github.com/Kurento/kms-core/tree/v5.1.1/src/server/interface)
- [KMS elements](https://github.com/Kurento/kms-elements/tree/v5.1.1/src/server/interface)
- [KMS filters](https://github.com/Kurento/kms-filters/tree/v5.1.1/src/server/interface)
As you can see in the links, I'm sticking to v5.1.1 instead of master.
