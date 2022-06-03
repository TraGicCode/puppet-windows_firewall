# frozen_string_literal: true

require 'spec_helper'

describe 'windows_firewall', type: :class do
  ['Windows 2012', 'Windows Server 2008', 'Windows Server 2008 R2', 'Windows 8', 'Windows 7'].each do |os|
    context "with OS: #{os}, ensure: running" do
      let :params do
        { ensure: 'running' }
      end

      it do
        is_expected.to contain_service('windows_firewall').with(
          'name' => 'MpsSvc',
          'ensure' => 'running',
          'enable' => 'true'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallDomainProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall',
          'data' => '1'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallPublicProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall',
          'data' => '1'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallStandardProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall',
          'data' => '1'
        )
      end
    end

    context "with OS: #{os}, ensure: stopped" do
      let :facts do
        { operatingsystemversion: os }
      end
      let :params do
        { ensure: 'stopped' }
      end

      it do
        is_expected.to contain_service('windows_firewall').with(
          'name' => 'MpsSvc',
          'ensure' => 'stopped',
          'enable' => 'false'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallDomainProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall',
          'data' => '0'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallPublicProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall',
          'data' => '0'
        )
      end

      it do
        is_expected.to contain_registry_value('EnableFirewallStandardProfile').with(
          'ensure' => 'present',
          'path' => '32:HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall',
          'data' => '0'
        )
      end
    end
  end
end
