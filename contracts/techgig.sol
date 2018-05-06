pragma solidity^ 0.4.10;

contract lending {


enum Industry
{
  agriculture,
  textile,
  women,
  education,
  refugees,
  technology,
  transportation,
  grocer,
  arts
}
  struct borrower {
    string aadhar_no;
    string name;
    address eth_add;
    string email;
    string phone;
    Business bus;
    uint rating;
    Address add;
  }

  struct Business
  {
    Industry ind;
    uint yearinbus;
    uint fundstillnow;
  }

  struct Address {
    string city;
    string country;
    string zip;
  }


  mapping (string => borrower) borrowermapping;
  mapping (string => Business) businessmapping;
  mapping (string => Address) addressmapping;


  function Register_Borrower(string aadhar,string _name,string _email,string _phone, uint _ind, uint _yearinbus, uint _funds, string _city, string _country, string _zip)
  {
      Industry  ind;
      ind=Industry(_ind);
    businessmapping[aadhar]=Business(ind,_yearinbus,_funds);
    addressmapping[aadhar]=Address(_city,_country,_zip);
    borrowermapping[aadhar]=borrower(aadhar,_name,msg.sender,_email,_phone,businessmapping[aadhar],0,addressmapping[aadhar]);

  }

  function displayBorrowerInfo(string aadhar) constant returns(string _aadhar,string name,string email,string phone,Industry ind,uint year,uint funds,uint rating,string city)
  {
    _aadhar=borrowermapping[aadhar].aadhar_no;
    name=borrowermapping[aadhar].name;
    email=borrowermapping[aadhar].email;
    phone=borrowermapping[aadhar].phone;
    ind=borrowermapping[aadhar].bus.ind;
    year=borrowermapping[aadhar].bus.yearinbus;
    funds=borrowermapping[aadhar].bus.fundstillnow;
    rating=borrowermapping[aadhar].rating;
    city=borrowermapping[aadhar].add.city;

  }

  struct lender
  {
    string aadhar;
    string name;
    address lender_add;
    string location;
  }

  mapping (string => lender) aadhartolendermapping;

  function add_lender(string aadhar,string name,string location)
  {
    aadhartolendermapping[aadhar]=lender(aadhar,name,msg.sender,location);
  }

  struct loan_req {
    uint amount;
    uint repaydate;
    address borrower;
    bool approved;
  }

  struct fieldpartners {
    string name;
    string location;
    string _type;
  }

mapping (address => borrower) addresstoborrower;
mapping (string => loan_req) loanreqtoaadhar;
  function req_loan(uint amount,uint repaydate)
  {
    string aadhar=addresstoborrower[msg.sender].aadhar_no;
    loanreqtoaadhar[aadhar]=loan_req(amount,repaydate,msg.sender,false);
  }
string[] loans;

  function ai_to_approve_loan(string borrower_aadhar)
  {
    loanreqtoaadhar[borrower_aadhar].approved=true;
    loans.push(borrower_aadhar);
  }

address[] lenders;
  mapping (string => address ) borroweraadhartostringmapping;
  mapping (address => uint) lendertoamountmapping;

  function lendmoney(string borrower_aadhar) payable
  {
    address borroweraddress=borroweraadhartostringmapping[borrower_aadhar];
    lendertoamountmapping[msg.sender]=msg.value;
    lenders.push(msg.sender);
    borroweraddress.transfer(msg.value);
    loanreqtoaadhar[borrower_aadhar].amount-=msg.value;
  }


 function lend() payable {
   this.transfer(msg.value);
 }
  function pay_back() payable
  {
    uint i;
    for(i=0;i<lenders.length;i++)
    {
      address lender=lenders[i];
      lender.transfer(lendertoamountmapping[lender]);
    }
  }

  function () payable {
  }


}
