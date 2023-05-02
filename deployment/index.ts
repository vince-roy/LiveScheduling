import * as digitalocean from "@pulumi/digitalocean";
import { readFileSync, writeFileSync } from "fs";
import * as yaml from "yaml";

// server
// IP
// DNS
// Postgres

// Database
const postgres = new digitalocean.DatabaseCluster("postgres-example", {
  engine: "pg",
  version: "15",
  size: "db-s-1vcpu-1gb",
  region: "nyc1",
  nodeCount: 1,
});
postgres.uri.apply((uri) =>
  writeFileSync("secrets.json", JSON.stringify({ DATABASE_URL: uri }))
);

const sshKey = new digitalocean.SshKey("default", {
  publicKey: process.env.SSH_PUBLIC as string,
});
const web = new digitalocean.Droplet("web", {
  image: "ubuntu-18-04-x64",
  region: "tor1",
  size: "s-1vcpu-1gb",
  sshKeys: [sshKey.fingerprint],
});
const mrsk = readFileSync("../config/deploy.yml", "utf8");
const mrskParsed = yaml.parse(mrsk);
web.ipv4Address.apply((ip) => {
  mrskParsed.servers = [ip];
  mrskParsed.builder.remote.host = `ssh://root@${ip}`;
  writeFileSync("../config/deploy.yml", yaml.stringify(mrskParsed));
});

const postgres_firewall = new digitalocean.DatabaseFirewall("postgres-fw", {
  clusterId: postgres.id,
  rules: [
    {
      type: "ip_addr",
      value: web.ipv4Address,
    },
  ],
});
