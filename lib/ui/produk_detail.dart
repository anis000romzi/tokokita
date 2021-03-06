import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/widget/success_dialog.dart';

class ProdukDetail extends StatefulWidget {
  Produk produk;
  ProdukDetail({this.produk});
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

enum Ukuran { kecil, sedang, besar }

class _ProdukDetailState extends State<ProdukDetail> {
  Ukuran _site = Ukuran.sedang;
  final _textJumlah = TextEditingController(text: '1');
  int harga_ukuran = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Detail Kue'),
      ),
      body: Center(
        child: Column(
          children: [
            new Image.asset(widget.produk.image),
            Text(
              widget.produk.namaProduk,
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Rp. ${widget.produk.hargaProduk.toString()}",
              style: TextStyle(fontSize: 18.0),
            ),
            Text("${widget.produk.deskripsiProduk}\n"),
            TextFormField(
                controller: _textJumlah,
                decoration: InputDecoration(labelText: "Jumlah Beli"),
                keyboardType: TextInputType.number),
            ListTile(
              title: const Text('Kecil'),
              leading: Radio(
                value:Ukuran.kecil,
                groupValue: _site,
                onChanged: (Ukuran value) {
                  setState(() {
                    _site = value;
                    harga_ukuran = -5000;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Sedang'),
              leading: Radio(
                value: Ukuran.sedang,
                groupValue: _site,
                onChanged: (Ukuran value) {
                  setState(() {
                    _site = value;
                    harga_ukuran = 0;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Besar'),
              leading: Radio(
                value: Ukuran.besar,
                groupValue: _site,
                onChanged: (Ukuran value) {
                  setState(() {
                    _site = value;
                    harga_ukuran = 5000;
                  });
                },
              ),
            ),
            _tombolBeli()
          ],
        ),
      ),
    );
  }

  Widget _tombolBeli() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Tombol Hapus
        ElevatedButton(
            child: Text("BELI"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () => confirmBeli()),
      ],
    );
  }

  void confirmBeli() {
    final juml = int.parse(_textJumlah.text);
    int total_harga = (widget.produk.hargaProduk + harga_ukuran) * juml;

    AlertDialog alertDialog = new AlertDialog(
      content: Text(
          "Apa anda yakin ingin membeli kue ini?\n Nama: ${widget.produk.namaProduk}\n Total harga: Rp. ${total_harga}"),
      actions: [
        //tombol hapus
        ElevatedButton(
          child: Text("Ya"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)),
          onPressed: () => sukses(),
        ),
        //tombol batal
        ElevatedButton(
          child: Text("Batal"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void sukses() {
     showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Pesanan akan segera dikirim",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
  }
}
