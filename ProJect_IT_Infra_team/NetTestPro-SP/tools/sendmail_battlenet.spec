# -*- mode: python -*-

block_cipher = None


a = Analysis(['sendmail_battlenet.py'],
             pathex=['E:\\MyDoc\\ITTOOL\\ProJect_IT_Only\\NetTestPro-SP\\tools'],
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
          name='sendmail_battlenet',
          debug=False,
          strip=False,
          upx=True,
          console=True )
