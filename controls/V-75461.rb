# frozen_string_literal: true

control 'V-75461' do
  title "The Ubuntu operating system must employ a FIPS 140-2 approved
cryptographic hashing algorithms for all stored passwords."
  desc  "The system must use a strong hashing algorithm to store the password.
The system must use a sufficient number of hashing rounds to ensure the
required level of entropy.

    Passwords need to be protected at all times, and encryption is the standard
method for protecting passwords. If passwords are not encrypted, they can be
plainly read (i.e., clear text) and easily compromised.


  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000073-GPOS-00041'
  tag "satisfies": %w[SRG-OS-000073-GPOS-00041 SRG-OS-000120-GPOS-00061]
  tag "gid": 'V-75461'
  tag "rid": 'SV-90141r1_rule'
  tag "stig_id": 'UBTU-16-010160'
  tag "fix_id": 'F-82089r1_fix'
  tag "cci": %w[CCI-000196 CCI-000803]
  tag "nist": ['IA-5 (1) (c)', 'IA-7', 'Rev_4']
  tag "false_negatives": nil
  tag "false_positives": nil
  tag "documentable": false
  tag "mitigations": nil
  tag "severity_override_guidance": false
  tag "potential_impacts": nil
  tag "third_party_tools": nil
  tag "mitigation_controls": nil
  tag "responsibility": nil
  tag "ia_controls": nil
  desc 'check', "Verify the shadow password suite configuration is set to
encrypt interactive user passwords using a strong cryptographic hash with the
following command:

Confirm that the interactive user account passwords are using a strong password
hash with the following command:

# sudo cut -d: -f2 /etc/shadow

$6$kcOnRq/5$NUEYPuyL.wghQwWssXRcLRFiiru7f5JPV6GaJhNC2aK5F3PZpE/BCCtwrxRc/AInKMNX3CdMw11m9STiql12f/

Password hashes \"!\" or \"*\" indicate inactive accounts not available for
logon and are not evaluated. If any interactive user password hash does not
begin with \"$6\", this is a finding."
  desc 'fix', "Configure the Ubuntu operating system to encrypt all stored
passwords with a strong cryptographic hash.

Lock all interactive user accounts not using SHA-512 hashing until the
passwords can be regenerated."

  non_interactive_shells = input('non_interactive_shells')
  ignore_shells = non_interactive_shells.join('|')
  counter = 0

  users.where { !shell.match(ignore_shells) }.entries.each do |user_info|
    shadow.where(user: user_info.username).passwords.each do |user_pwd|
      pwd_should_be_evaluated = !(user_pwd.casecmp?('!') || user_pwd.casecmp?('*'))
      next unless pwd_should_be_evaluated

      describe (user_info.username + ' - user\'s password hash') do
        subject { user_pwd }
        it { should start_with '$6' }
      end
      counter += 1
    end
  end
  if counter == 0
    describe 'Number of interactive users on the system' do
      subject { counter }
      it { should be 0 }
    end
  end
end
