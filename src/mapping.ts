import { Transfer as TransferEvent } from "../generated/USDC/USDC"
import { Transfer } from "../generated/schema"

export function handleTransfer(event: TransferEvent): void {
  let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  let entity = new Transfer(id)

  entity.from = event.params.from
  entity.to = event.params.to
  entity.value = event.params.value
  entity.blockNumber = event.block.number
  entity.timestamp = event.block.timestamp
  entity.txHash = event.transaction.hash

  entity.save()
}
