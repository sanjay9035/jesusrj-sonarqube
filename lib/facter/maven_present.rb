Facter.add("maven_present") do
  confine :kernel => 'Linux'
  setcode do
    version = Facter::Util::Resolution.exec('mvn --version')
    if version && version.chomp.split("\n")[0].split(" ")[2]
      true
    else
      false
    end
  end
end
