# frozen_string_literal: true

control 'V-75793' do
  title "Successful/unsuccessful uses of the finit_module command must generate
an audit record."
  desc  "Without generating audit records that are specific to the security and
mission needs of the organization, it would be difficult to establish,
correlate, and investigate the events relating to an incident or identify those
responsible for one.

    Audit records can be generated from various components within the
information system (e.g., module or policy filter).


  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000037-GPOS-00015'
  tag "satisfies": %w[SRG-OS-000037-GPOS-00015 SRG-OS-000042-GPOS-00020
                      SRG-OS-000062-GPOS-00031 SRG-OS-000392-GPOS-00172
                      SRG-OS-000462-GPOS-00206 SRG-OS-000471-GPOS-00215]
  tag "gid": 'V-75793'
  tag "rid": 'SV-90473r3_rule'
  tag "stig_id": 'UBTU-16-020840'
  tag "fix_id": 'F-82423r2_fix'
  tag "cci": %w[CCI-000130 CCI-000135 CCI-000169 CCI-000172
                CCI-002884]
  tag "nist": ['AU-3', 'AU-3 (1)', 'AU-12 a', 'AU-12 c', 'MA-4 (1) (a)',
               'Rev_4']
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
  desc 'check', "Verify the Ubuntu operating system generates an audit record
when successful/unsuccessful attempts to use the \"finit_module\" command occur.

Check that the following calls are being audited by performing the following
command to check the file system rules in \"/etc/audit/audit.rules\":

# sudo grep -w \"finit_module\" /etc/audit/audit.rules

-a always,exit -F arch=b64 -S finit_module -F auid>=1000 -F auid!=4294967295 -k
module_chng

If the command does not return a line, or the line is commented out, this is a
finding."
  desc 'fix', "Configure the audit system to generate an audit event for any
successful/unsuccessful use of the \"finit_module\" command.

Add or update the following rules in the \"/etc/audit/audit.rules\" file:

-a always,exit -F arch=b64 -S finit_module -F auid>=1000 -F auid!=4294967295 -k
module_chng

The audit daemon must be restarted for the changes to take effect. To restart
the audit daemon, run the following command:

# sudo systemctl restart auditd.service"

  if os.arch == 'x86_64'
    describe auditd.syscall('finit_module').where { arch == 'b64' } do
      its('action.uniq') { should eq ['always'] }
      its('list.uniq') { should eq ['exit'] }
    end
  end
  describe auditd.syscall('finit_module').where { arch == 'b32' } do
    its('action.uniq') { should eq ['always'] }
    its('list.uniq') { should eq ['exit'] }
  end
end
