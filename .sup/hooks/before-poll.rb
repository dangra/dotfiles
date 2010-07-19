def offlineimap()
  `offlineimap -q -u Noninteractive.Basic 2>&1`
end

if (@last_fetch || Time.at(0)) < Time.now - 120
  say "Running offlineimap..."
  log offlineimap
  say "Finished offlineimap run."
end
@last_fetch = Time.now
