baseline
baseline: spec
<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Cmfcmf-WinFFI' with: [
				spec
					repository: 'github://cmfcmf/SqueakUtils:master';
					loads: #('winffi')];
			package: 'MagicMouse-Core' with: [spec requires: #('Cmfcmf-WinFFI')].
		spec
			group: 'default' with: #('MagicMouse-Core');
			yourself];    
	yourself