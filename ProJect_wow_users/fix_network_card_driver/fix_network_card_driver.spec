# -*- mode: python -*-

block_cipher = None


a = Analysis(['fix_network_card_driver.py'],
             pathex=['E:\\MyDoc\\ITTOOL\\ProJect_wow_users\\fix_network_card_driver'],
             binaries=None,
             datas=None,
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='fix_network_card_driver',
          debug=False,
          strip=False,
          upx=True,
          console=True )
