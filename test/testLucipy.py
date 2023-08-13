import unittest
import lucipy

class TestLucipy(unittest.TestCase):

    def test_a2hex_00(self):
        rawkey = 'SUPERSECRET'
        key = lucipy.a2hex(rawkey)
        expKey = '53555045525345435245542020202020'.encode('UTF-8')
        self.assertEqual(expKey,key)
        
    def test_a2hex_01(self):
        rawmsg = 'ATTACK AT DAWN'
        msg = lucipy.a2hex(rawmsg)
        expMsg = '41545441434B204154204441574E2020'.encode('UTF-8')
        self.assertEqual(expMsg,msg)
        
    def test_hex2a_02(self):
        key = '53555045525345435245542020202020'
        rawkey = lucipy.hex2a(key)
        expKey = 'SUPERSECRET'.encode('UTF-8')
        self.assertEqual(expKey,rawkey)
        
    def test_hex2a_03(self):
        msg = '41545441434B204154204441574E2020'
        rawmsg = lucipy.hex2a(msg)
        expMsg = 'ATTACK AT DAWN'.encode('UTF-8')
        self.assertEqual(expMsg,rawmsg)

    def test_cipher_10(self):
        key = '0123456789ABCDEFFEDCBA9876543210'
        msg = 'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB'
        expected = '7C790EFDE03679E4BF28FE2D199E41A0'.encode('UTF-8')
        resulted = lucipy.cipher(0,key,msg)
        self.assertEqual(resulted,expected)
        
    def test_cipher_11(self):
        key = '0123456789ABCDEFFEDCBA9876543210'
        msg = '7C790EFDE03679E4BF28FE2D199E41A0'
        expected = 'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB'.encode('UTF-8')
        resulted = lucipy.cipher(1,key,msg)
        self.assertEqual(resulted,expected)
        
    def test_cipher_12(self):
        key = '0123456789ABCDEFFEDCBA9876543210'
        msg = '7C790EFDE03679E4BF28FE2D199E41A0'
        resulted = lucipy.cipher(1,key,lucipy.cipher(0,key,msg))
        self.assertEqual(resulted,msg.encode('UTF-8'))
        
    def test_cipher_13(self):
        key = '0123456789ABCDEFFEDCBA9876543210'
        msg = '7C790EFDE03679E4BF28FE2D199E41A0'
        resulted = lucipy.cipher(0,key,lucipy.cipher(1,key,msg))
        self.assertEqual(resulted,msg.encode('UTF-8'))
        
    def test_encode_decode(self):
        rawkey = '25Novembre1981'
        key = lucipy.a2hex(rawkey)
        rawmsg = 'Naissance de moi'
        msg = lucipy.a2hex(rawmsg)
        self.assertEqual(  lucipy.hex2a( lucipy.cipher(0,key,lucipy.cipher(1,key,msg))),rawmsg.encode('UTF-8'))
        
if __name__ == '__main__':
    unittest.main()


