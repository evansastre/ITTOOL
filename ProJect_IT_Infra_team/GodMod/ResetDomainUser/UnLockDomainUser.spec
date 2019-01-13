# -*- mode: python -*-
a = Analysis(['E:\\MyDoc\\ITTOOL\\ProJect_IT_Only\\GodMod\\UnLockDomainUser\\UnLockDomainUser.py'],
             pathex=['E:\\MyDoc\\ITTOOL\\ProJect_IT_Only\\GodMod\\ResetDomainUser'],
             hiddenimports=[],
             hookspath=None,
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='UnLockDomainUser.exe',
          debug=False,
          strip=None,
          upx=True,
          console=False )
