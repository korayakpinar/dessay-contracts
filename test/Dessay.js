const { expect } = require("chai");

describe("Dessay", function () {
  let Dessay;
  let dessay;
  let DessayToken;
  let dessayToken;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    DessayToken = await ethers.getContractFactory("DessayToken");
    dessayToken = await DessayToken.deploy();
    await dessayToken.deployed();

    Dessay = await ethers.getContractFactory("Dessay");
    dessay = await Dessay.deploy(dessayToken.address);
    await dessay.deployed();
  });

  it("should enter writing", async function () {
    const topics = [
      ethers.utils.formatBytes32String("Felsefe"),
      ethers.utils.formatBytes32String("BilimKurgu"),
    ];
    await dessay.enterWriting(
      "Test Writing",
      "IPFS Address",
      topics,
      100
    );
    const writings = await dessay.getWrites(owner.address);
    expect(writings.length).to.equal(1);
    expect(writings[0].header).to.equal("Test Writing");
    expect(writings[0].topics).to.deep.equal(topics);
  });

  it("should add a reply", async function () {
    await dessay.enterWriting(
      "Test Writing",
      "IPFS Address",
      [],
      100
    );
    const writings = await dessay.getWrites(owner.address);
    const writingId = writings[0].id.toNumber();
    await dessay.reply(owner.address, "Test Reply", writingId);
    const comments = await dessay.getComments(writingId);
    expect(comments.length).to.equal(1);
    expect(comments[0].publisher).to.equal(owner.address);
    expect(comments[0].content).to.equal("Test Reply");
  });

  it("should upvote a writing", async function () {
    await dessayToken.approve(dessay.address, 100);
    await dessay.enterWriting(
      "Test Writing",
      "IPFS Address",
      [],
      100
    );
    const writings = await dessay.getWrites(owner.address);
    const writingId = writings[0].id.toNumber();
    await dessay.upvote(50, writingId);
    const upvotes = await dessay.addrToUpvotes(owner.address);
    expect(upvotes.length).to.equal(1);
    expect(upvotes[0].amount).to.equal(50);
    expect(upvotes[0].id).to.equal(writingId);
  });
});