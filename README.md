# solace-perftests

SDKPerf client scripts for Solace Message Bus testing

* `nonpersistent\_fanout/runtest <rate> <size> <duration> <fanout>`

+---------------+----------------------+
| Persistence   | Msg Exchange Pattern |
| ==============|======================+
| Nonpersistent | 1 : M |
| ==============|======================+

Runs a non-persistent messaging test with one publisher fanning out messages 
of a configured size and at a configured rate to a configurable number of 
consumers.

Verifies number of messages sent and aggregate number received.

* `nonpersistent\_latency/runtest <rate> <size> <duration> <flows>`

+---------------+----------------------+
| Persistence   | Msg Exchange Pattern |
| ==============|======================+
| Nonpersistent | 1 : 1 |
| ==============|======================+

Runs a non-persistent latency test with a configurable number of publisher/consumer pairs 
at a configured message size and rate quantifying the latencies according to:
* Average
* 50th percentile
* 95th percentile
* 99th percentile
* 99.9th percentile
* Standard deviation

Verifies aggregate number of messages sent and aggregate number received.

* `persistent\_fanout/runtest <rate> <size> <duration> <fanout>`

+---------------+----------------------+
| Persistence   | Msg Exchange Pattern |
| ==============|======================+
| Persistent    | 1 : M |
| ==============|======================+

Runs a persistent messaging test with one publisher fanning out messages 
of a configured size and at a configured rate to a configurable number of 
consumers.

Verifies number of messages sent and aggregate number received.

* `persistent\_pt2pt/runtest <rate> <size> <duration> <flows>`

+---------------+----------------------+
| Persistence   | Msg Exchange Pattern |
| ==============|======================+
| Persistent    | 1 : 1 |
| ==============|======================+

Runs a persistent messaging test with a configurable number of publisher/consumer pairs 
of a configured message size and rate.
consumers.

Verifies number of messages sent and received.

