import unittest
import lucipy

class TestLucipy(unittest.TestCase):

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
        
if __name__ == '__main__':
    unittest.main()


