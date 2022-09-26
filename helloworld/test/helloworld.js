const HelloWorld = artifacts.require("helloworld");

contract("HelloWorld", (accounts) => {
  it("should say hello", async () => {
    const instance = await HelloWorld.deployed();
    const sayHello = await instance.sayHello.call("Joey");
    assert.equal(sayHello, 'Hello:Joey');
  });
});
